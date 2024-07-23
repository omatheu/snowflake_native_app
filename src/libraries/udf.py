def percentage_difference(customer_sales, regional_sales):
    # Check if regional sales is not zero to avoid division by zero
    if regional_sales != 0:
        return round(abs((customer_sales - regional_sales) / regional_sales) * 100, 2)
    else:
        # Return None or an appropriate value if regional sales is zero
        return None