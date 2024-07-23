import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import count_distinct, col, sum
import snowflake.permissions as permission
from sys import exit

st.set_page_config(layout="wide")
session = get_active_session()

def load_app(customer_sales):
    with st.spinner("Please wait..."):

        # Query to join the tables and calculate the percentage difference using Snowflake UDF
        query = f"""
        SELECT 
            t1.product_type as "Product Category", 
            t1.quantity as "Customer Sales Quantity", 
            t2.quantity as "Regional Sales Quantity",
            app_instance_schema.percentage_difference(t1.quantity, t2.quantity) as "% Difference"
        FROM {customer_sales} as t1
        INNER JOIN REGIONAL_SALES as t2
        ON t1.product_type = t2.product_type
        """

        combined_df = session.sql(query).to_pandas()

        st.subheader("Snowy Sales Avalanche: Q3 2024 Sales Data")
        # Display the dataframe with the new column names
        st.dataframe(combined_df)

        
customer_sales_reference_associations = permission.get_reference_associations("customer_sales")
if len(customer_sales_reference_associations) == 0:
    permission.request_reference("customer_sales")
    exit(0)

st.title("Product Sales Comparison: Customer vs. Regional Sales")
customer_sales = "reference('customer_sales')"

load_app(customer_sales)