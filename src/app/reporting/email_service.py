import os
import glob
import smtplib

from dotenv import load_dotenv, find_dotenv
from email.message import EmailMessage

load_dotenv(find_dotenv())


def send_email():

    sender = os.getenv("EMAIL_USER")
    password = os.getenv("EMAIL_PASSWORD")
    recipient = os.getenv("RECIPIENT_EMAIL")

    if not sender:
        raise ValueError("EMAIL_USER is missing")

    if not password:
        raise ValueError("EMAIL_PASSWORD is missing")

    if not recipient:
        raise ValueError("RECIPIENT_EMAIL is missing")

    msg = EmailMessage()

    msg["Subject"] = "Monthly IBAN Change Reports"
    msg["From"] = sender
    msg["To"] = recipient

    msg.set_content(
        """
Hello,

Please find attached the monthly IBAN Change Reports.

Each Excel file contains IBAN change records for a specific market.

Regards,
Analytics Engineering
        """
    )

    report_files = glob.glob("IBAN_Change_Report_*.xlsx")

    if not report_files:
        raise ValueError("No report files found")

    for file_name in report_files:

        with open(file_name, "rb") as f:

            msg.add_attachment(
                f.read(),
                maintype="application",
                subtype="vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename=os.path.basename(file_name)
            )

    with smtplib.SMTP_SSL(
        "smtp.gmail.com",
        465
    ) as smtp:

        smtp.login(
            sender,
            password
        )

        smtp.send_message(msg)

    print(
        f"Email sent successfully with {len(report_files)} attachments"
    )