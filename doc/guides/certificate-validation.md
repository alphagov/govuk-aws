# Certificate Validation

If a certificate is registered through Amazon, then a few steps will be required to enable validation of the certificate.

## DNS

Ensure a Route 53 domain exists for the root domain of the certificate you are purchasing for.

For example, if you are buying a certificate for foo.bar.example.com, Amazon will do a lookup for MX records down the chain of domains. It will lookup MX records for foo.bar.example.com, then bar.example.com, and finally example.com until it finds an appropriate MX record.

It will send the validation email to the email address which has the valid MX record.

## Email receiving

To receive the validation email, we need to have email receiving set up on Amazon Simple Email Service (SES) for that domain (if there is no valid email address already).

### Create domain

First you must "Verify a New Domain" in Identity Management within SES. This requires setting a DNS record for the domain you are trying to receive mail on.

If you are using an internal only domain, a public domain must be created to allow the SES domain registration to happen. The validation will only happen against an external lookup.

### Create email address

When the domain is validated in SES, create an email address. This will probably be `hostmaster@`, as this is the address that Amazon will send the certificate validation email to.

### Create a rule set

Create a new "Rule Set" in the "Email Receiving" section of SES.

Give the rule a name, add the recipient we just created, and add the action to forward the email to an S3 bucket. If you select the S3 bucket option, it will give you the option to choose which bucket to use, or it will also offer to create the bucket on your behalf.

**Be sure to enable the rule set as "active" when it has been created**

### Pick up the email

When the bucket and rule set has been created, send the certificate validation email. It should appear in the bucket; open up the email, and click the link inside to validate the certificate.
