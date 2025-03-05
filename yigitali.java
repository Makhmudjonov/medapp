public void generateRecommendations(UserInfo userInfo) {
        double bmi = calculateBMI(userInfo.getWeight(), userInfo.getHeight());
        if (userInfo.getAge() > 60 ||
                bmi >= 30 || bmi <= 18.5 ||
                userInfo.getSystolic() >= 140 || userInfo.getSystolic() <= 100 ||
                userInfo.getDiastolic() >= 90 || userInfo.getDiastolic() <= 60 ||
                userInfo.getRestingHeartRate() >= 90 || userInfo.getRestingHeartRate() <= 50 ||
                userInfo.getCovidInfectionSeverity().equals(CovidSeverityLevel.SEVERE) ||
                userInfo.getTreatmentStatus().equals(CovidTreatmentStatus.ICU_WITH_INTENSIVE_CARE) ||
                userInfo.getInfectionDurationDays() >= 28
        ) {
            userInfo.setLoadLevel(PhysicalLoadLevel.LIGHT);

        } else if (
                userInfo.getAge() < 60 && (bmi > 18.5 && bmi <= 29.9) &&
                        userInfo.getSystolic() >= 120 && userInfo.getSystolic() <= 139 &&
                        userInfo.getDiastolic() > 80 && userInfo.getDiastolic() <= 89 &&
                        userInfo.getRestingHeartRate() >= 60 && userInfo.getRestingHeartRate() < 89 &&
                        userInfo.getCovidInfectionSeverity().equals(CovidSeverityLevel.MODERATE) &&
                        userInfo.getTreatmentStatus().equals(CovidTreatmentStatus.ICU_WITHOUT_IVL) &&
                        userInfo.getInfectionDurationDays() >= 14 && userInfo.getInfectionDurationDays() < 27
        ) {
            userInfo.setLoadLevel(PhysicalLoadLevel.MODERATE);
        } else if (
                userInfo.getAge() < 60 && (bmi > 18.5 && bmi <= 24.5) &&
                        userInfo.getSystolic() >= 110 && userInfo.getSystolic() <= 120 &&
                        userInfo.getDiastolic() >= 70 && userInfo.getDiastolic() <= 80 &&
                        userInfo.getRestingHeartRate() >= 60 && userInfo.getRestingHeartRate() <= 80 &&
                        userInfo.getCovidInfectionSeverity().equals(CovidSeverityLevel.MILD) &&
                        userInfo.getTreatmentStatus().equals(CovidTreatmentStatus.NOT_HOSPITALIZED) &&
                        userInfo.getInfectionDurationDays()<=14
        ) {
            userInfo.setLoadLevel(PhysicalLoadLevel.ADVANCED);
        }
    }