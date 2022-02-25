from predict import predictor
sample_two = [{
"Year":2014,
"Selling_Price":3.35,
"Present_Price":5.59,
"Kms_Driven":27000,
"Fuel_Type":"Petrol",
"Seller_Type":"Dealer",
"Transmission":"Manual",
"Owner":0
    },
{
"Year":2014,
"Selling_Price":3.35,
"Present_Price":5.59,
"Kms_Driven":27000,
"Fuel_Type":"Petrol",
"Seller_Type":"Dealer",
"Transmission":"Manual",
"Owner":0
    }
]
res = predictor(sample_two)
print(res)