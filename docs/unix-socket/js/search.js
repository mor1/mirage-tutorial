$(document).ready(function () {
        function signame(x) { return ('sig'+x.split(".").join("-")); }

        function update_content(a) {
            console.log("Updating "+a);
            var e = $('#'+signame(a)).clone();
            $('#center').html(e);
        };

        function update_tree_content(e, id) { 
            var a = $.jstree._focused().get_selected()[0].id.replace(/^tree/,"");
            update_content(a);
        };

        /* Convert an info description into HTML nodes */
        $.fn.addInfo = function(info) {  
            var s = info.description; /* TODO: rewrite the anchor tags within the descr */
            var d = $('<div />').addClass('sig-description').html(s);
            return $(this).append(d);
        }  

        /* Convert a signature data structure into HTML nodes */
        $.fn.addSig = function(sigdata) {
            var name = sigdata.name;
            var info = sigdata.info;
            // XXX very hackish
            if (sigdata.module_structure) {
                var module_structure = sigdata.module_structure;
            } else if (sigdata.module_with.module_alias) {
                var alias = sigdata.module_with.module_alias;
                if (alias.module_type) {
                    if (alias.module_type.module_structure) {
                        var module_structure = alias.module_type.module_structure;
                    } else {
                        var module_structure = [];
                    };
                } else {
                    var module_structure = [];
                };
            };

            function stripModule(x) { return x.replace(name+".",''); }
            function stripType(x) {
                return x.split(" ").map(stripModule).join(" ");
            };
            var d = $("<div />").attr('id', signame(name));
            d.append($("<div />")
                     .addClass('sig-header')
                     .append($("<h2 />").text(name)));
            d.append($("<div />")
                     .addClass('sig-info')
                     .append($("<p/>").html(info.description)));
            $.each(module_structure, function(e,x) {
                    if (x.type) {
                        var s = "type ";
                        if (x.type.params.length > 1) { s = s + "(" };
                        $.each(x.type.params, function (p,params) {
                                if (params.covariant && !params.contravariant) s += "+";
                                if (!params.covariant && params.contravariant) s += "-";
                                if (p>1) { s = s + ", " };
                                s = s + stripType(params.type) + " ";
                            });
                        if (x.type.params.length > 1) { s = s + ") " };
                        s += "<strong>" + stripModule(x.type.name) + "</strong>";
                        if (x.type.kind.type == "variant") {
                            s += " =";
                            $.each(x.type.kind.constructors, function(k,con) {
                                    s += "<br />| " + con.name;
                                    if (con.type.length > 0) s += " of " + $.map(con.type, stripType).join(' * ');
                                    if (con.description) s += "  (* " + con.description + " *)";
                                });
                        }
                        d.append($("<div />")
                                 .addClass('sig-type')
                                 .addClass("alert-message block-message success")
                                 .append($("<div/>").addClass("alert-message success").html(s))
                                 .addInfo(x.type.info));
                    } else if (x.comment) {
                        d.append($("<div />")
                                 .addClass('sig-comment')
                                 .html($.trim(x.comment)));
                    } else if (x.value) {
                        var s = "val <strong>" + stripModule(x.value.name) + "</strong> : " + stripType(x.value.type);
                        d.append($("<div />")
                                 .addClass('sig-value')
                                 .addClass("alert-message block-message")
                                 .append($("<div/>").addClass("alert-message").html(s))
                                 .addInfo(x.value.info));
                    } else if (x.exception) {
                        var s = "exception <strong>" + stripModule(x.exception.name) + "</strong>";
                        d.append($("<div />")
                                 .addClass('sig-exception')
                                 .addClass("alert-message block-message info")
                                 .append($("<div/>").addClass("alert-message info").html(s))
                                 .addInfo(x.exception.info));

                    } else if (x.module_type) {
                        var s = "module type <strong>"+stripModule(x.module_type.name)+"</strong> : sig ... end";
                        d.append($("<div />")
                                 .addClass('sig-module-type')
                                 .addClass("alert-message block-message success")
                                 .append($("<div/>").addClass("alert-message success").html(s))
                                 .addInfo(x.module_type.info));
                        $('#sigs').addSig(x.module_type);

                    } else if (x.module) {
                        var s = "module <strong>" + stripModule(x.module.name) + "</strong> : ";
                        function mkarg(m) {
                            var r = "";
                            if (m.module_alias) {
                                r += "<strong>"+stripModule(m.module_alias.name)+"</strong>";
                            };
                            if (m.module_with) {
                                r += "<strong>"+stripModule(m.module_with.module_alias.name)+"</strong>";

                                if (m.module_with.with) {
                                    r += " " + m.with;
                                };
                            };
                            return r;
                        };
                        function mkfunctor(m) {
                            if (m.module_functor) {
                                var param = m.module_functor.parameter;
                                s += "functor " + "(" + param.name + " : " + mkarg(param) + ") -> ";
                                mkfunctor(m.module_functor);
                            } else if (m.module_with) {
                                s += mkarg(m.module_with);
                            };
                        };
                        mkfunctor(x.module);
                        d.append($("<div />")
                                 .addClass('sig-module')
                                 .addClass("alert-message block-message")
                                 .append($("<div/>").addClass("alert-message").html(s))
                                 .addInfo(x.module.info));
                        if (x.module.module_functor) {
                            //var m = $.extend( {"name": x.module.name}, alias.module_type);
                            //$('#sigs').addSig(m);
                        } else {
                            $('#sigs').addSig(x.module);
                        };
                    } else {
                        d.append($("<div />")
                                 .addClass("alert-message block-message error")
                                 .html($("<pre>"+JSON.stringify(x)+"</pre>")));
                    }
                });
            d.find(".code").replaceWith(function (){
                    return $("<code/>").html($(this).contents());
                });
            d.find(".codepre").replaceWith(function (){
                    return $("<pre/>").html($(this).contents());
                });
            d.find("a").replaceWith(function (){
                    return $(this).contents();
                });
            $("#sigs").append(d);
        }

        $('#sigs').hide();

        function renderTree(data) {
            $('#thetree').jstree({
                    core: { animation: 20 },
                        plugins: ['themes', 'json_data', 'ui', 'search', 'sort'],
                        themes: { icons: true, dots: true },
                        search: { show_only_matches: true, case_insensitive: true, },
                        UI: { select_limit:-1 },
                        json_data: { 'data' : data.tree }
                }).bind("select_node.jstree", update_tree_content);
            $('#modsearch').keyup(function (e) { 
                    var v = $('#modsearch').val();
                    if (v == '') {
                        $('#thetree').jstree('clear_search');
                    } else {
                        $('#thetree').jstree('search', v);
                    }
                });
        };

        $.ajax({
                url: 'data/info.json',
                    dataType: 'json',
                    error: function(x) { console.log('ERR'+x); },
                    success: function(data) {
                    renderTree(data);
                    $.each(data.info, function(m) {
                            $('#sigs').addSig(data.info[m].module);
                        });
                }
            });

    });
