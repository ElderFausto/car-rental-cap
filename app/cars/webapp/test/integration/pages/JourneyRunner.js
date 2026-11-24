sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"car/rental/cars/test/integration/pages/CarsList.gen",
	"car/rental/cars/test/integration/pages/CarsObjectPage.gen",
	"car/rental/cars/test/integration/pages/RentalsObjectPage.gen"
], function (JourneyRunner, CarsListGenerated, CarsObjectPageGenerated, RentalsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('car/rental/cars') + '/test/flp.html#app-preview',
        pages: {
			onTheCarsListGenerated: CarsListGenerated,
			onTheCarsObjectPageGenerated: CarsObjectPageGenerated,
			onTheRentalsObjectPageGenerated: RentalsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

