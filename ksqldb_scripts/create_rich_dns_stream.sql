CREATE STREAM RICH_DNS WITH (PARTITIONS=1, VALUE_FORMAT='AVRO') AS 
SELECT d."query", 
    d."id.orig_h" AS SRC_IP, 
    d."id.resp_h" AS DEST_IP,
    d."id.orig_p" AS SRC_PORT, 
    d."id.resp_h" AS DEST_PORT, 
    d.QTYPE_NAME, 
    d.TTLS, 
    SPLIT(d."query", '.')[1] AS HOSTNAME, 
    SPLIT(d."query", '.')[2] AS ELEMENT2, 
    SPLIT(d."query", '.')[3] AS ELEMENT3, 
    SPLIT(d."query", '.')[4] AS ELEMENT4, 
    d.ANSWERS, 
    d.TS, 
    d.UID, 
    c.UID, 
    c.ORIG_IP_BYTES AS REQUEST_BYTES, 
    c.RESP_IP_BYTES AS REPLY_BYTES, 
    c.LOCAL_ORIG 
FROM DNS_STREAM d INNER JOIN CONN_STREAM c WITHIN 1 MINUTES ON d.UID = c.UID WHERE LOCAL_ORIG = true;