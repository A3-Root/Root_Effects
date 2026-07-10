// Shared sea, underwater and water shader parameter block that recolors the
// engine water to blood red. Expanded once per supported terrain class.

#define ROOT_WATERCOLOR_SEA \
    class Sea { \
        seaTexture = "a3\data_f\seatexture_co.paa"; \
        seaMaterial = "#water"; \
        shoreMaterial = "#shore"; \
        shoreFoamMaterial = "#shorefoam"; \
        shoreWetMaterial = "#shorewet"; \
        WaterMapScale = 20; \
        WaterGrid = 50; \
        MaxTide = 0; \
        MaxWave = 0.2; \
        SeaWaveXScale = 0.04; \
        SeaWaveZScale = 0.02; \
        SeaWaveHScale = 1; \
        SeaWaveXDuration = 75000; \
        SeaWaveZDuration = 10000; \
    }; \
    class Underwater { \
        noWaterFog = -0.3; \
        fullWaterFog = 0.1; \
        deepWaterFog = 10; \
        waterFogDistance = 10; \
        waterFogDistanceNear = 5; \
        waterColor[] = {0.4, 0, 0}; \
        deepWaterColor[] = {0.4, 0, 0}; \
        surfaceColor[] = {0.4, 0, 0}; \
        deepSurfaceColor[] = {0.4, 0, 0}; \
    }; \
    class SeaWaterShaderPars { \
        refractionMoveCoef = 0.01; \
        waterOpacityDistCoef = 0.07; \
        underwaterOpacity = 0.5; \
        waterOpacityFadeStart = 50; \
        waterOpacityFadeLength = 5; \
    }; \
    class WaterExPars: WaterExPars { \
        surfaceOpacity = 0.76; \
        fogDensity = 0.2; \
        fogColor[] = {0.4, 0, 0}; \
        fogColorExtinctionSpeed[] = {0.032814, 0.0149, 0.00511}; \
        ligtExtinctionSpeed[] = {0.032814, 0.0149, 0.00511}; \
        diffuseLigtExtinctionSpeed[] = {0.036814, 0.0449, 0.02511}; \
        fogGradientCoefs[] = {1, 1, 1}; \
        fogColorLightInfluence[] = {0.5, 0.2, 0.5}; \
        shadowIntensity = 1; \
        ssReflectionStrength = 0; \
        ssReflectionMaxJitter = 1; \
        ssReflectionRippleInfluence = 0.2; \
        ssReflectionEdgeFadingCoef = 0; \
        ssReflectionDistFadingCoef = 0; \
        refractionMinCoef = 0.03; \
        refractionMaxCoef = 0.14; \
        refractionMaxDist = 5.1; \
        specularMaxIntensity = 1000; \
        specularPowerOvercast0 = 1000; \
        specularPowerOvercast1 = 1000; \
        specularNormalModifyCoef = 0.015; \
        foamAroundObjectsIntensity = 0.05; \
        foamAroundObjectsFadeCoef = 8; \
        foamColorCoef = 1; \
        foamDeformationCoef = 0.02; \
        foamTextureCoef = 0.2; \
        foamTimeMoveSpeed = 0.2; \
        foamTimeMoveAmount = 0.01; \
        shoreDarkeningMaxCoef = 0.45; \
        shoreDarkeningOffset = 0.36; \
        shoreDarkeningGradient = 0.08; \
        shoreWaveTimeScale = 0.8; \
        shoreWaveShifDerivativeOffset = -0.8; \
        shoreFoamIntensity = 0.005; \
        shoreMaxWaveHeight = 0.02; \
        shoreWetLayerReflectionIntensity = 0.55; \
    }
