function doGet(e) {
     var spreadsheetId = '1uXklKUKO7-9wfPxUY5rTtAtd5EY68lX0AZpzGpHLiYY';
     var group41 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group41_Latest');
     var group23 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group23_Latest');
     var group75 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group75_Latest');
     var group68 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group68_Latest');

    // getSheetValues(startRow, startColumn, numRows, numColumns) -- startRow = group3.getLastRow()
     // .reduce(function(a, b){return a.concat(b);})
     var results_group41 = [[]];
     var results_group23 = [[]];
     var results_group75 = [[]];
     var results_group68 = [[]];

     if (group41.getLastRow() > 1) {
        results_group41 = group41.getSheetValues(2, 1, group41.getLastRow() - 1, 9);
     }
     if (group23.getLastRow() > 1) {
        results_group23 = group23.getSheetValues(2, 1, group23.getLastRow() - 1, 9);
     }
     if (group75.getLastRow() > 1) {
        results_group75 = group75.getSheetValues(2, 1, group75.getLastRow() - 1, 9);
     }
     if (group68.getLastRow() > 1) {
        results_group68 = group68.getSheetValues(2, 1, group68.getLastRow() - 1, 9);
     }

      Logger.log(results_group41);
      Logger.log(results_group23);
      Logger.log(results_group75);
      Logger.log(results_group68);

     var results = [];
     results.push(results_group41);
     results.push(results_group23);
     results.push(results_group75);
     results.push(results_group68);

     Logger.log(results);

    return ContentService.createTextOutput(
     e.parameters.callback + '(' + JSON.stringify(results) + ')'
    ).setMimeType(ContentService.MimeType.JAVASCRIPT);
   }
