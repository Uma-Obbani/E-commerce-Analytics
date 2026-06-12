from datetime import datetime
import hashlib

BANKS = [
    {
        "bank_name": "Commerzbank",
        "bic": "COBADEFFXXX"
    },
    {
        "bank_name": "ING",
        "bic": "INGDDEFFXXX"
    },
    {
        "bank_name": "Deutsche Bank",
        "bic": "DEUTDEFFXXX"
    },
    {
        "bank_name": "Santander",
        "bic": "SCFBDE33XXX"
    },
    {
        "bank_name": "Sparkasse",
        "bic": "HELADEF1XXX"
    },
    {
        "bank_name": "HypoVereinsbank",
        "bic": "HYVEDEMMXXX"
    }
]


def generate_mock_record(uuid):

    hash_value = int(hashlib.md5(uuid.encode()).hexdigest(), 16)

    bank = BANKS[hash_value % len(BANKS)]

    iban_number = str(hash_value % (10**20)).zfill(20)

    return {
        "uuid": uuid,
        "created_on": datetime.utcnow().isoformat() + "Z",
        "account": {
            "holder": f"Customer_{uuid[:8]}",
            "iban": f"DE{iban_number}",
            "bic": bank["bic"],
            "bank_name": bank["bank_name"]
        }
    }