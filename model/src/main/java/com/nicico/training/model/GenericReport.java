package com.nicico.training.model;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class GenericReport {

    private Long id;
    private String title;
    private String complex;
    private String baseOnComplex;
    private String assistant;
    private String baseOnAssistant;
    private String darsadMoavenatAzMojtame;
    private String affairs;
    private String baseOnAffairs;
    private String darsadOmorAzMoavenat;
    private String darsadOmorAzMojtame;

    public GenericReport(Long id, String title, String complex, String baseOnComplex, String assistant, String baseOnAssistant, String darsadMoavenatAzMojtame, String affairs, String baseOnAffairs, String darsadOmorAzMoavenat, String darsadOmorAzMojtame) {
        this.id = id;
        this.title = title;
        this.complex = complex;
        this.baseOnComplex = baseOnComplex;
        this.assistant = assistant;
        this.baseOnAssistant = baseOnAssistant;
        this.darsadMoavenatAzMojtame = darsadMoavenatAzMojtame;
        this.affairs = affairs;
        this.baseOnAffairs = baseOnAffairs;
        this.darsadOmorAzMoavenat = darsadOmorAzMoavenat;
        this.darsadOmorAzMojtame = darsadOmorAzMojtame;
    }
}
