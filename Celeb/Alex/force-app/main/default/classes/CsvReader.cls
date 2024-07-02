/*************************************************************************************************************
Name:  ContactUploaderController
==============================================================================================================
Purpose: Apex class to parse CSV files
==============================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                                             DATE           DETAIL          Description
1.0      Scutariu Lucian                                  13/01/2024      Created         Initial version
**************************************************************************************************************/
public with sharing class CsvReader {
    public static List<Map<String, String>> parse(String csvContent) {
        List<Map<String, String>> result = new List<Map<String, String>>();

        // Split the CSV content into lines
        List<String> lines = csvContent.split('\n');

        // Assume the first line contains headers
        List<String> headers = lines[0].split(',');

        for (Integer i = 1; i < lines.size(); i++) {
            List<String> values = lines[i].split(',');

            // Skip empty lines
            if (values.isEmpty()) {
                continue;
            }

            Map<String, String> record = new Map<String, String>();
            for (Integer j = 0; j < Math.min(headers.size(), values.size()); j++) {
                // Check if the value is not missing
                if (values.size() > j) {
                    // Handle values enclosed in double quotes and escaping
                    String header = headers[j].trim();
                    String value = values[j].trim();

                    if (value.startsWith('"') && value.endsWith('"')) {
                        // Remove quotes if present
                        value = value.substring(1, value.length() - 1);
                    }

                    // Unescape double quotes
                    value = value.replaceAll('""', '"');

                    record.put(header, value);
                } else {
                    // If the value is missing, set an empty string
                    record.put(headers[j], '');  // No trim for headers
                }
            }

            result.add(record);
        }

        return result;
    }
}


