import time

from dotenv import load_dotenv

load_dotenv()


from langchain_chroma import Chroma

from langchain_google_genai import (
    GoogleGenerativeAIEmbeddings
)

from ai_engine.bigquery_client import (
    get_customer_context
)


VECTOR_PATH = "vector_store"


def build_vector_store():

    print(
        "Loading customer context from BigQuery..."
    )


    df = get_customer_context()


    print(
        f"Loaded {len(df)} customers"
    )


    # Gemini embedding model
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/gemini-embedding-001"
    )


    # Create Chroma vector DB
    vector_db = Chroma(

        persist_directory=VECTOR_PATH,

        embedding_function=embeddings

    )


    # Text from dbt AI mart
    texts = (

        df["ai_marketing_summary"]

        .fillna("")

        .astype(str)

        .tolist()

    )


    # Save customer id with every vector
    metadata = [

        {
            "customer_id": str(row.customer_id)
        }

        for row in df.itertuples()

    ]


    # Gemini free tier protection
    batch_size = 20


    for i in range(
        0,
        len(texts),
        batch_size
    ):


        batch_texts = texts[
            i:i + batch_size
        ]


        batch_metadata = metadata[
            i:i + batch_size
        ]


        vector_db.add_texts(

            texts=batch_texts,

            metadatas=batch_metadata

        )


        print(
            f"Processed {min(i + batch_size, len(texts))}/{len(texts)} customers"
        )


        # avoid Gemini quota limit
        time.sleep(45)


    print(
        "Vector store created successfully"
    )



if __name__ == "__main__":

    build_vector_store()