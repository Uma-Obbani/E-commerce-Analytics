from dotenv import load_dotenv

load_dotenv()


from langchain_chroma import Chroma

from langchain_google_genai import (
    GoogleGenerativeAIEmbeddings,
    ChatGoogleGenerativeAI
)


VECTOR_PATH = "vector_store"


# Same embedding model used while creating vectors
embeddings = GoogleGenerativeAIEmbeddings(
    model="models/gemini-embedding-001"
)


# Load existing Chroma database
vector_db = Chroma(

    persist_directory=VECTOR_PATH,

    embedding_function=embeddings

)


# Gemini LLM
llm = ChatGoogleGenerativeAI(

    model="gemini-2.5-flash",

    temperature=0

)

def ask(question):


    # Retrieve similar customer contexts
    docs = vector_db.similarity_search(

        question,

        k=5

    )


    context = "\n\n".join(

        [
            doc.page_content
            for doc in docs
        ]

    )


    prompt = f"""

You are an AI Marketing Analytics Copilot.

You help business users understand ecommerce customers.

Use ONLY the customer intelligence context below.

Explain clearly with:
- customer behavior
- churn risk
- customer value
- recommended marketing actions


CUSTOMER DATA:

{context}


USER QUESTION:

{question}


ANSWER:

"""


    response = llm.invoke(
        prompt
    )


    return response.content



if __name__ == "__main__":


    result = ask(

        "Which customers have high churn risk?"

    )


    print(result)