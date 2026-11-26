using {car.rental as db} from '../db/schema';

// 1. Definição do Serviço (Cria as rotas /odata/v4/rental/Cars e /odata/v4/rental/Rentals)
service RentalService @(path: '/odata/v4/rental') {
  @odata.draft.enabled
  entity Cars    as projection on db.Cars;

  entity Rentals as projection on db.Rentals;
};

// 2. Anotações Fiori Elements (Ensina o Fiori a desenhar a tela sem precisar programar HTML/JS)
annotate RentalService.Cars with @(
  // Define quais colunas aparecem na tabela principal (List Report)
  UI.LineItem  : [
    {
      Value: brand,
      Label: '{i18n>Brand}'
    },
    {
      Value: model,
      Label: '{i18n>Model}'
    },
    {
      Value: plate,
      Label: '{i18n>Plate}'
    },
    {
      Value: dailyRate,
      Label: '{i18n>DailyRate}'
    },
    {
      Value: status,
      Label: '{i18n>Status}'
    }
  ],
  // Define o título da página de detalhes ao clicar em um carro (Object Page)
  Ui.HeaderInfo: {
    TypeName      : '{i18n>Car}',
    TypeNamePlural: '{i18n>Cars}',
    Title         : {Value: model},
    Description   : {Value: brand}
  }
);
