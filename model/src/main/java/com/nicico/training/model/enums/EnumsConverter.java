package com.nicico.training.model.enums;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 11:01 AM
*/

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

public abstract class EnumsConverter {

    @Converter(autoApply = true)
    public static class EEnabledConverter implements AttributeConverter<EEnabled, Integer> {
        @Override
        public Integer convertToDatabaseColumn(EEnabled entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EEnabled convertToEntityAttribute(Integer id) {
            for (EEnabled entry : EEnabled.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class EDeletedConverter implements AttributeConverter<EDeleted, Integer> {
        @Override
        public Integer convertToDatabaseColumn(EDeleted entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EDeleted convertToEntityAttribute(Integer id) {

            for (EDeleted entry : EDeleted.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ECompetenceInputTypeConverter implements AttributeConverter<ECompetenceInputType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ECompetenceInputType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ECompetenceInputType convertToEntityAttribute(Integer id) {

            for (ECompetenceInputType entry : ECompetenceInputType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class EDomainTypeConverter implements AttributeConverter<EDomainType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EDomainType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EDomainType convertToEntityAttribute(Integer id) {

            for (EDomainType entry : EDomainType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class EJobCompetenceTypeConverter implements AttributeConverter<EJobCompetenceType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EJobCompetenceType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EJobCompetenceType convertToEntityAttribute(Integer id) {

            for (EJobCompetenceType entry : EJobCompetenceType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ELevelTypeConverter implements AttributeConverter<ELevelType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ELevelType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ELevelType convertToEntityAttribute(Integer id) {

            for (ELevelType entry : ELevelType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ERunTypeConverter implements AttributeConverter<ERunType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ERunType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ERunType convertToEntityAttribute(Integer id) {

            for (ERunType entry : ERunType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ETheoTypeConverter implements AttributeConverter<ETheoType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ETheoType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ETheoType convertToEntityAttribute(Integer id) {

            for (ETheoType entry : ETheoType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ETechnicalTypeConverter implements AttributeConverter<ETechnicalType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ETechnicalType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ETechnicalType convertToEntityAttribute(Integer id) {

            for (ETechnicalType entry : ETechnicalType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class EInstituteTypeConverter implements AttributeConverter<EInstituteType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EInstituteType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EInstituteType convertToEntityAttribute(Integer id) {

            for (EInstituteType entry : EInstituteType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

    @Converter(autoApply = true)
    public static class ELicenseTypeConverter implements AttributeConverter<ELicenseType, Integer> {

        @Override
        public Integer convertToDatabaseColumn(ELicenseType entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public ELicenseType convertToEntityAttribute(Integer id) {

            for (ELicenseType entry : ELicenseType.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

	@Converter(autoApply = true)
    public static class EMilitaryConverter implements AttributeConverter<EMilitary, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EMilitary entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EMilitary convertToEntityAttribute(Integer id) {

            for (EMilitary entry : EMilitary.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

     @Converter(autoApply = true)
    public static class EMarriedConverter implements AttributeConverter<EMarried, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EMarried entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EMarried convertToEntityAttribute(Integer id) {

            for (EMarried entry : EMarried.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

     @Converter(autoApply = true)
    public static class EGenderConverter implements AttributeConverter<EGender, Integer> {

        @Override
        public Integer convertToDatabaseColumn(EGender entry) {
            return entry != null ? entry.getId() : null;
        }

        @Override
        public EGender convertToEntityAttribute(Integer id) {

            for (EGender entry : EGender.values()) {
                if (entry.getId().equals(id)) {
                    return entry;
                }
            }
            return null;
        }
    }

}





























