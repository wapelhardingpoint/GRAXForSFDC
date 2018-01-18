![GRAX by Harding Point](https://static.wixstatic.com/media/fa96ca_4cb02045be8445468545da7de475da38~mv2.png/v1/fill/w_334,h_128,al_c,usm_0.66_1.00_0.01/fa96ca_4cb02045be8445468545da7de475da38~mv2.png)

# GRAX by Harding Point Salesforce SDK

The GRAX by Harding Point Salesforce SDK uses the [GRAX Cloud](https://www.grax.io/) services to help you solve complex problems by applying graph theory to your Salesforce environment(s).

## Installation

There are two supported installation methods: automatically using Salesforce DX, manually using Salesforce DX. By default, all classes in the SDK will be deployed to your Salesforce org.

### Salesforce DX Automatic deployment

You can automatically deploy the SDK to a new scratch environment using the _Deploy to SFDX_ button.

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/)

### Salesforce DX Manual deployment

1. Clone this repository from GitHub using the following command:

    ```bash
    git clone https://github.com/HardingPoint/GRAXForSFDC
    ```

1. Create a new scratch environment (optional if you don't want to re-use an existing one):

    ```bash
    sfdx force:org:create -a grax-sdk -s -f config/project-scratch-def.json
    ```

1. Push the source to the scratch environment:

    ```bash
    sfdx force:source:push
    ```

If you want to use the GRAX SDK within a non-scratch environment you can deploy it using the Salesforce DX CLI.

1. Authenticate the Salesforce DX CLI to the target environment:

    ```bash
    sfdx force:auth:web:login --setdefaultusername
    ```
    In the browser window that opens, sign in to your org with your credentials. More information [here](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_web_flow.htm)

1. Create an output directory:

    ```bash
    mkdir mdapioutput
    ```

1. Convert the source code:

    ```bash
    sfdx force:source:convert -d mdapioutput/
    ```

1. Deploy the source code:

    ```bash
    sfdx force:mdapi:deploy -d mdapioutput/ -w 100
    ```

