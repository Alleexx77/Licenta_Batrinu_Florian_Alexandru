(function s() {
    return (function evaledScript() {
        $A.componentService.addComponentClass("markup://aura:unescapedHtml", function() {
            return {
                meta: {
                    name: "aura$unescapedHtml"
                },
                renderer: {
                    render: function(b) {
                        var a = b.get("v.value");
                        $A.util.isUndefinedOrNull(a) && (a = "");
                        a = $A.util.createElementsFromMarkup(a);
                        a.length || (a = $A.renderingService.renderFacet(b, a));
                        return a
                    },
                    rerender: function(b) {
                        if (b.isDirty("v.value")) {
                            var a = b.getElement()
                              , c = null;
                            a ? (c = document.createTextNode(""),
                            $A.util.insertBefore(c, a)) : c = $A.renderingService.getMarker(b);
                            $A.unrender(b);
                            a = $A.render(b);
                            a.length && ($A.util.insertBefore(a, c),
                            $A.afterRender(b))
                        }
                    },
                    unrender: function(b) {
                        for (var a = b.getElements(), c = 0; c < a.length; c++)
                            $A.util.removeElement(a[c]);
                        b.disassociateElements()
                    }
                }
            }
        });
        return {
            "xs": "G",
            "descriptor": "markup://aura:unescapedHtml",
            "ad": [["body", "aura://Aura.Component[]", "G", false, []], ["value", "aura://String", "G", false]],
            "i": ["markup://aura:rootComponent"],
            "css": true
        }
    }
    )
}
)()

