%dw 2.0
output application/json  skipNullOn="everywhere"
---
if (payload.status == 204)
  payload
else
  {
    resourceType: "Bundle",
    "type": "searchset",
    link: [
      {
        relation: "self"
      }
    ],
    meta: {
      lastUpdated: now()
    },
    entry: payload map (payload01, indexOfPayload01) -> {
      resourceType: "CarePlan",
      id: payload01."PATIENT_HM_KEY",
      subject: {
        reference: payload01."PATIENT_ID"
      },
      identifier: [
        {
          assigner: {
            reference: payload01."SOURCE_PARTNER_NAME"
          }
        }
      ],
      title: payload01.TOPIC,
      activity: [
        {
          detail: {
            scheduledPeriod: {
              end: 
                if (not payload01."DUE_DATE" == null)
                  payload01."DUE_DATE" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "MM/dd/yyyy"}
                else
                  null
            }
          }
        }
      ],
      status: payload01.STATUS,
      period: {
        end: 
          if (not payload01."DATE_COMPLETE" == null)
            payload01."DATE_COMPLETE" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "MM/dd/yyyy"}
          else
            null
      }
    }
  }