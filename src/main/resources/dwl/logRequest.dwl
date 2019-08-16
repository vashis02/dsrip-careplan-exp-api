%dw 2.0
output application/java
---
'AllergyIntolerance-PRS API Entry' ++
write(
 {
 	"SVC_ID": vars.apiName ,
 	"Correlation ID ":vars.correlationId,
 	"Start Time":vars.startTime
 }, "application/java")
 	