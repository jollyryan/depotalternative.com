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

