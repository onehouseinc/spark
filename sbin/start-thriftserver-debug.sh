#! /bin/bash

EVENT_LOGS_DIR="$(pwd)/logs"

cd dist

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""

./sbin/start-thriftserver.sh \
    --conf spark.sql.catalogImplementation=hive \
    --conf spark.sql.hive.metastore.jars=builtin \
    --conf spark.hadoop.hive.imetastoreclient.factory.class=com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory \
    --conf spark.driver.extraJavaOptions="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005" \
    --conf spark.eventLog.enabled=true \
    --conf spark.eventLog.dir=${EVENT_LOGS_DIR} \
    --conf spark.hadoop.aws.region='us-west-2' \
    --conf spark.serializer='org.apache.spark.serializer.KryoSerializer' \
    --conf spark.sql.extensions='org.apache.spark.sql.hudi.HoodieSparkSessionExtension' \
    --conf spark.sql.catalog.spark_catalog='org.apache.spark.sql.hudi.catalog.HoodieCatalog' \
    --conf spark.kryo.registrator='org.apache.spark.HoodieSparkKryoRegistrar'
