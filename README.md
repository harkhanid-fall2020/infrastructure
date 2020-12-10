# infrastructure

## Steps to run Infrastructure Repository
1. run the following command in your terminal
```yml 
git clone git@github.com:harkhanid/infrastructure.git
```
2. export your aws profile in which you want to create VPC. 
3. open 01 folder in your terminal

4. run the following commands
```yml
packer init
packer plan
packer apply
```

Command to Add certificate:
```yml
aws acm import-certificate --certificate fileb://prod_dharmikharkhanicr.pem --private-key fileb://prod_dharmikharkhanipk.rsa --certificate-chain fileb://prod_dharmikharkhanica.pem

```