(function s() {
    return (function evaledScript() {
        $A.componentService.addComponentClass("markup://aura:renderIf", function() {
            return {
                meta: {
                    name: "aura$renderIf",
                    "extends": "markup://aura:component"
                },
                controller: {
                    init: function(a) {
                        var e = $A.util.getBooleanValue(a.get("v.isTrue"))
                          , b = a.get("v.body")
                          , c = a.get("v.else")
                          , d = a.get("v.template");
                        b.length && !d.length && (d = b);
                        for (var b = [d, c], f = 0; f < b.length; f++)
                            for (var g = 0; g < b[f].length; g++)
                                b[f][g].autoDestroy(!1);
                        a.set("v.template", d, !0);
                        a.set("v.body", e ? d : c, !0)
                    },
                    destroy: function(a) {
                        a = [a.get("v.template"), a.get("v.else")];
                        for (var e = 0; e < a.length; e++)
                            for (var b = 0; b < a[e].length; b++)
                                a[e][b].destroy()
                    },
                    facetChange: function(a, e) {
                        if (!a.updating) {
                            var b, c, d = [e.getParam("value"), e.getParam("oldValue")];
                            for (c = 0; c < d.length; c++) {
                                $A.util.isArray(d[c]) || (d[c] = [d[c]]);
                                for (b = 0; b < d[c].length; b++)
                                    d[c][b].autoDestroy(!0)
                            }
                            var f = $A.util.getBooleanValue(a.get("v.isTrue"));
                            b = a.get("v.body");
                            var g = a.get("v.else")
                              , h = a.get("v.template");
                            b !== h && (h = b);
                            d = [h, g];
                            for (c = 0; c < d.length; c++)
                                for (b = 0; b < d[c].length; b++)
                                    d[c][b].autoDestroy(!1);
                            a.updating = !0;
                            a.set("v.body", f ? h : g);
                            a.updating = !1
                        }
                    },
                    updateBody: function(a) {
                        var e = $A.util.getBooleanValue(a.get("v.isTrue"));
                        a.updating = !0;
                        a.set("v.body", e ? a.get("v.template") : a.get("v.else"));
                        a.updating = !1
                    }
                },
                renderer: {
                    render: function(a) {
                        return a.getRendering() || $A.renderingService.renderFacet(a, a.get("v.body"))
                    },
                    afterRender: function(a) {
                        a = a.get("v.body");
                        $A.afterRender(a)
                    },
                    rerender: function(a) {
                        var e = a.get("v.body");
                        return $A.renderingService.rerenderFacet(a, e)
                    },
                    unrender: function(a) {
                        var e = a.get("v.body");
                        $A.renderingService.unrenderFacet(a, e)
                    }
                }
            }
        });
        return {
            "xs": "G",
            "descriptor": "markup://aura:renderIf",
            "ad": [["body", "aura://Aura.Component[]", "G", false, []], ["isTrue", "aura://Boolean", "G", true], ["else", "aura://Aura.Component[]", "G", false, []], ["template", "aura://Aura.Component[]", "p", false, []]],
            "hd": [{
                "x": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "c.init"
                },
                "v": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "this"
                },
                "n": "init"
            }, {
                "x": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "c.destroy"
                },
                "v": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "this"
                },
                "n": "destroy"
            }, {
                "x": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "c.updateBody"
                },
                "v": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "v.isTrue"
                },
                "n": "change"
            }, {
                "x": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "c.facetChange"
                },
                "v": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "v.body"
                },
                "n": "change"
            }, {
                "x": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "c.facetChange"
                },
                "v": {
                    "exprType": "PROPERTY",
                    "byValue": false,
                    "path": "v.else"
                },
                "n": "change"
            }],
            "css": true
        }
    }
    )
}
)()
//# sourceURL=https://gr1692952391382.my.site.com/components/aura/renderIf.js
