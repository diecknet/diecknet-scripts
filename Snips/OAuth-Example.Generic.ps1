<# 
Step 1: Retrieve the OAuth Token from the API provider.
        It depends on the provider, how it actually works.
        This is an example using https://dummyjson.com/docs/auth
#>

$RestParameterAuth = @{
    Method = "POST"
    ContentType = "application/json"
    Uri = "https://dummyjson.com/auth/login"
    Body = ConvertTo-Json @{
        username = "kminchelle"
        password = "0lelplR"
    }
}
# optional: use try/catch for error handling
$AuthenticationResult = Invoke-RestMethod @RestParameterAuth

# The example API returns several fields. 
# We're mainly interested in the "token" property.
# Other APIs might have a different fieldname for the token. 

# save the token in a variable for later usage
$Token = $AuthenticationResult.token

<#
Step 2: Use the token from Step 1 to do an authenticated request against the API. 
#>

$RestParameterRequest = @{
    Method = "GET"
    Uri = "https://dummyjson.com/carts/user/15" # represents the cart of a user
    Headers = @{
        Authorization = "Bearer $Token"
    }
    ContentType = "application/json"
}
$RequestResult = Invoke-RestMethod @RestParameterRequest

# Output result:
# $RequestResult
$RequestResult.carts