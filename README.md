# snowplow-realtime


1. git clone git@github.com:petersiemen/snowplow-realtime.git
2. cp example.source.sh source.sh
3. update source.sh with your data
4. terraform foundational AWS resources
    ```
    cd production/foundation
    source ../../source.sh
    AWS_PROFILE=XYZ terragrunt apply-all 
    ```
5. Build an package necessary AWS Lambda functions
    * git clone git@github.com:snowplow-starter-aws/lambda-tsv-to-json-transformer.git
    * git clone git@github.com:snowplow-starter-aws/lambda-json-to-postgres-loader.git
    * update Makefile in lambda-tsv-to-json-transformer with your AWS_PROFILE 
    ```
    make build.image && make package
    ```
    * update Makefile in lambda-json-to-postgres-loader with your AWS_PROFILE 
    ```
    make build.image && make package
    ```
6. terraform snowplow AWS resources
    ```
    cd production/snowplow
    source ../../source.sh
    AWS_PROFILE=XYZ terragrunt apply-all 
    ```   
7.  git@github.com:snowplow-starter-aws/5-data-modeling.git
    * update postgres.properties with your data
    ```
    mvn clean install
    ./migrate.sh
    ``` 