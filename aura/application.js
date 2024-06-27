(function s() {
    return (function evaledScript() {
        $A.componentService.addComponentClass("markup://aura:application", function() {
            return {
                meta: {
                    name: "aura$application"
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
                        var b = a.get("v.body");
                        return $A.renderingService.rerenderFacet(a, b)
                    },
                    unrender: function(a) {
                        var b = a.get("v.body");
                        $A.renderingService.unrenderFacet(a, b)
                    }
                }
            }
        });
        return {
            "xs": "G",
            "descriptor": "markup://aura:application",
            "ad": [["body", "aura://Aura.Component[]", "G", false, []]],
            "i": ["markup://aura:rootComponent"],
            "ab": true,
            "lc": "markup://aura:locationChange",
            "tk": {
                "mqLarge": "only screen and (min-width: 64.0625em)",
                "uiModal.container": "slds-modal__container",
                "uiModal.header": "slds-modal__header",
                "uiModal.title": "slds-text-heading_medium",
                "mqSingleColumnRecordLayout": "(max-width: 599px)",
                "uiModal.body": "slds-modal__content",
                "mqMediumLandscape": "only screen and (min-width: 48em) and (min-aspect-ratio: 4/3)",
                "uiLabel.label": "",
                "mqHighRes": "only screen and (-webkit-min-device-pixel-ratio: 2), screen and (min-device-pixel-ratio: 2),screen and (min-resolution: 192dpi),screen and (min-resolution: 2dppx)",
                "uiButton.is-selected": "slds-is-selected",
                "lightning.standardSprite": "/_slds/icons/standard-sprite/svg/symbols.svg?cache=10.8.2",
                "lightning.utilitySpriteRtl": "/_slds/icons/utility-sprite/svg/symbols_rtl.svg?cache=10.8.2",
                "uiModal.bodySpacing": "slds-p-around_medium",
                "mqMedium": "only screen and (min-width: 48em)",
                "mqSmall": "only screen and (max-width: 47.9375em)",
                "uiButton.not-selected": "slds-not-selected",
                "lightning.actionSprite": "/_slds/icons/action-sprite/svg/symbols.svg?cache=10.8.2",
                "uiModal.backdrop": "slds-backdrop",
                "lightning.customSprite": "/_slds/icons/custom-sprite/svg/symbols.svg?cache=10.8.2",
                "uiPanel.truncate": "slds-truncate",
                "uiLabel.assistive": "",
                "lightning.doctypeSpriteRtl": "/_slds/icons/doctype-sprite/svg/symbols_rtl.svg?cache=10.8.2",
                "uiModal.headerEmpty": "slds-modal__header_empty",
                "lightning.utilitySprite": "/_slds/icons/utility-sprite/svg/symbols.svg?cache=10.8.2",
                "uiModal.backdropOpen": "slds-backdrop_open",
                "lightning.customSpriteRtl": "/_slds/icons/custom-sprite/svg/symbols_rtl.svg?cache=10.8.2",
                "lightning.actionSpriteRtl": "/_slds/icons/action-sprite/svg/symbols_rtl.svg?cache=10.8.2",
                "lightning.standardSpriteRtl": "/_slds/icons/standard-sprite/svg/symbols_rtl.svg?cache=10.8.2",
                "uiButton.button": "slds-button slds-button_neutral",
                "uiModal.modal": "slds-modal",
                "uiModal.modalOpen": "slds-fade-in-open",
                "lightning.doctypeSprite": "/_slds/icons/doctype-sprite/svg/symbols.svg?cache=10.8.2",
                "uiModal.footer": "slds-modal__footer"
            },
            "css": true
        }
    }
    )
}
)()
