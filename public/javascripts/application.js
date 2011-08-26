// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
    $("#suppliers_wrapper .pagination a").live("click", function() {
        $.getScript(this.href);
        return false;
    });

    $("#suppliers_search").submit(function() {
        $.get(this.action, $(this).serialize(), null, "script");
        return false;
    });
});