$(document).ready(function(){
  // var folioView = new FolioView();
  folioView = new FolioView();
  $("#add-element").on("click", function() {
    folioView.toggleSidebar();
  });
});
