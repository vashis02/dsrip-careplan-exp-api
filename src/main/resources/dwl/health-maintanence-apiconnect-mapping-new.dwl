%dw 2.0
output application/json  skipNullOn="everywhere"
---
if (payload.status == 204)
  payload
else
  {
    resourceType: "Bundle",
    "type": "searchset",
    meta: {
      lastUpdated: now()
    },
    entry: payload map (payload01, indexOfPayload01) -> {
      fullUrl: "https://apiconnect-dev.mountsinai.org/api/CarePlan/" ++ indexOfPayload01,
      resource: {
        resourceType: "CarePlan",
        id: payload01."PATIENT_HM_KEY",
        subject: {
          display: payload01."PATIENT_ID"
        },
        identifier: [
          {
            assigner: {
              display: payload01."SOURCE_PARTNER_NAME"
            }
          }
        ],
        intent: "order",
        title: payload01.TOPIC,
        activity: [
          {
            detail: {
              scheduledPeriod: {
                end: 
                  if (not payload01."DUE_DATE" == null)
                    payload01."DUE_DATE" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "yyyy-MM-dd"}
                  else
                    null
              },
              status: "unknown"
            }
          }
        ],
        status: 
          if (payload01.STATUS == "Completed")
            "completed"
          else
            "unknown",
        period: {
          end: 
            if (not payload01."DATE_COMPLETE" == null)
              payload01."DATE_COMPLETE" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "yyyy-MM-dd"}
            else
              null
        }
      }
    }
  }