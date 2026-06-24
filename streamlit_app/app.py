import sys
from pathlib import Path


# Add project root folder to Python path
ROOT_DIR = Path(__file__).resolve().parents[1]

sys.path.append(
    str(ROOT_DIR)
)


import streamlit as st

from ai_engine.rag_engine import ask



# -----------------------
# Page configuration
# -----------------------

st.set_page_config(
    page_title="E-Commerce AI Copilot",
    page_icon="🤖",
    layout="wide"
)


# -----------------------
# Header
# -----------------------

st.title(
    "🛒 E-Commerce AI Marketing Copilot"
)

st.write(
    """
Ask questions about customer behavior,
churn risk, customer value, and marketing actions.
"""
)


# -----------------------
# Chat memory
# -----------------------

if "messages" not in st.session_state:

    st.session_state.messages = []


# Display old messages

for message in st.session_state.messages:

    with st.chat_message(
        message["role"]
    ):

        st.write(
            message["content"]
        )


# -----------------------
# User input
# -----------------------

question = st.chat_input(
    "Ask about your customers..."
)


if question:


    # show user question

    st.session_state.messages.append(

        {
            "role": "user",
            "content": question
        }

    )


    with st.chat_message(
        "user"
    ):

        st.write(
            question
        )


    # Generate AI answer

    with st.chat_message(
        "assistant"
    ):


        with st.spinner(
            "Analyzing customer intelligence..."
        ):


            response = ask(
                question
            )


            st.write(
                response
            )


    # save assistant response

    st.session_state.messages.append(

        {
            "role": "assistant",
            "content": response
        }

    )