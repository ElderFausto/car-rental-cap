using RentalService as service from '../../srv/rental-service';

annotate service.Cars with @(
    UI.HeaderInfo                : {
        TypeName      : '{i18n>Car}',
        TypeNamePlural: '{i18n>Cars}',
        Title         : {Value: model},
        Description   : {Value: brand}
    },
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                Label: '{i18n>Brand}',
                Value: brand
            },
            {
                Label: '{i18n>Model}',
                Value: model
            },
            {
                Label: '{i18n>Plate}',
                Value: plate
            },
            {
                Label: '{i18n>DailyRate}',
                Value: dailyRate
            },
            {
                Label: '{i18n>Status}',
                Value: status
            }
        ]
    },
    UI.Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'Informações do Carro',
        Target: '@UI.FieldGroup#GeneratedGroup'
    }],
    UI.LineItem                  : [
        {
            Label: '{i18n>Brand}',
            Value: brand
        },
        {
            Label: '{i18n>Model}',
            Value: model
        },
        {
            Label: '{i18n>Plate}',
            Value: plate
        },
        {
            Label: '{i18n>DailyRate}',
            Value: dailyRate
        },
        {
            Label: '{i18n>Status}',
            Value: status
        }
    ]
);
