PackageSources = src/Base.m src/Braids.m src/TubePlot.m \
	src/DrawPD.m src/Data.m src/BraidData.m src/GaussCode.m \
	src/GC2PD.m src/Indiana.m src/HOMFLYPT.m \
	src/Kauffman.m src/Kh.m src/MorseLink.m src/DrawMorseLink.m \
	src/ML2PD.m src/AlexanderConway.m src/VogelsAlgorithm.m \
	src/MultivariableAlexander.m src/REngine.m src/TestRMatrix.m \
	src/CJREngine.m src/ColouredJones.m

all: KnotTheory.tar.gz KnotTheory.zip DTCodes4Knots12To16.tar.gz \
	DTCodes4Knots12To16.zip

KnotTheory/init.m:	src/System.mm $(PackageSources) KnotTheory/JavaKh/*;
	/bin/rm -f KnotTheory/init.m
	cat src/System.mm > KnotTheory/init.m
	cat $(PackageSources) >> KnotTheory/init.m

KnotTheory.tar.gz: KnotTheory/*.m KnotTheory/JavaKh/*;
	tar cvf KnotTheory.tar KnotTheory/*.m KnotTheory/JavaKh/*
	gzip -9 KnotTheory.tar

KnotTheory.zip: KnotTheory/*.m KnotTheory/JavaKh/*;
	/bin/rm -f KnotTheory.zip
	zip -r KnotTheory.zip KnotTheory/*.m KnotTheory/JavaKh/*

DTCodes4Knots12To16.tar.gz: KnotTheory/*.dts;
	tar cvf DTCodes4Knots12To16.tar KnotTheory/*.dts
	gzip -9 DTCodes4Knots12To16.tar

DTCodes4Knots12To16.zip: KnotTheory/*.dts;
	/bin/rm -f web/DTCodes4Knots12To16.zip
	zip -r DTCodes4Knots12To16.zip KnotTheory/*.dts
