weather_source_schema = """
{
  "name": "weather",
  "type": "record",
  "namespace": "com.entechlog",
  "fields": [
    {
      "name": "lat",
      "type": "float"
    },
    {
      "name": "lon",
      "type": "float"
    },
    {
      "name": "timezone",
      "type": "string"
    },
    {
      "name": "timezone_offset",
      "type": "int"
    },
    {
      "name": "current",
      "type": {
        "name": "current",
        "type": "record",
        "fields": [
          {
            "name": "dt",
            "type": "int"
          },
          {
            "name": "sunrise",
            "type": "int"
          },
          {
            "name": "sunset",
            "type": "int"
          },
          {
            "name": "temp",
            "type": "float"
          },
          {
            "name": "feels_like",
            "type": "float"
          },
          {
            "name": "pressure",
            "type": "int"
          },
          {
            "name": "humidity",
            "type": "int"
          },
          {
            "name": "dew_point",
            "type": "float"
          },
          {
            "name": "uvi",
            "type": "float"
          },
          {
            "name": "clouds",
            "type": "int"
          },
          {
            "name": "visibility",
            "type": "int"
          },
          {
            "name": "wind_speed",
            "type": "int"
          },
          {
            "name": "wind_deg",
            "type": "int"
          },
          {
            "name": "weather",
            "type": {
              "type": "array",
              "items": {
                "name": "weather_record",
                "type": "record",
                "fields": [
                  {
                    "name": "id",
                    "type": "int"
                  },
                  {
                    "name": "main",
                    "type": "string"
                  },
                  {
                    "name": "description",
                    "type": "string"
                  },
                  {
                    "name": "icon",
                    "type": "string"
                  }
                ]
              }
            }
          }
        ]
      }
    },
    {
      "name": "daily",
      "type": {
        "type": "array",
        "items": {
          "name": "daily_record",
          "type": "record",
          "fields": [
            {
              "name": "dt",
              "type": "int"
            },
            {
              "name": "sunrise",
              "type": "int"
            },
            {
              "name": "sunset",
              "type": "int"
            },
            {
              "name": "temp",
              "type": {
                "name": "temp",
                "type": "record",
                "fields": [
                  {
                    "name": "day",
                    "type": "float"
                  },
                  {
                    "name": "min",
                    "type": "float"
                  },
                  {
                    "name": "max",
                    "type": "float"
                  },
                  {
                    "name": "night",
                    "type": "float"
                  },
                  {
                    "name": "eve",
                    "type": "float"
                  },
                  {
                    "name": "morn",
                    "type": "float"
                  }
                ]
              }
            },
            {
              "name": "feels_like",
              "type": {
                "name": "feels_like",
                "type": "record",
                "fields": [
                  {
                    "name": "day",
                    "type": "float"
                  },
                  {
                    "name": "night",
                    "type": "float"
                  },
                  {
                    "name": "eve",
                    "type": "float"
                  },
                  {
                    "name": "morn",
                    "type": "float"
                  }
                ]
              }
            },
            {
              "name": "pressure",
              "type": "int"
            },
            {
              "name": "humidity",
              "type": "int"
            },
            {
              "name": "dew_point",
              "type": "float"
            },
            {
              "name": "wind_speed",
              "type": "float"
            },
            {
              "name": "wind_deg",
              "type": "int"
            },
            {
              "name": "weather",
              "type": {
                "type": "array",
                "items": {
                  "name": "daily_weather_record",
                  "type": "record",
                  "fields": [
                    {
                      "name": "id",
                      "type": "int"
                    },
                    {
                      "name": "main",
                      "type": "string"
                    },
                    {
                      "name": "description",
                      "type": "string"
                    },
                    {
                      "name": "icon",
                      "type": "string"
                    }
                  ]
                }
              }
            },
            {
              "name": "clouds",
              "type": "int"
            },
            {
              "name": "pop",
              "type": "float"
            },
            {
              "name": "uvi",
              "type": "float"
            }
          ]
        }
      }
    }
  ]
}
"""