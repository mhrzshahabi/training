package com.nicico.training.model;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class TypeOfEnterToClassReport {

    private Long id;
    private String title;
    private String complex;
    private Double baseOnComplex;
    private String assistant;
    private Double baseOnAssistant;
    private Double darsadAzComplex;
    private String affairs;
    private Double baseOnAffairs;
    private Double darsadAzOmor;

    public TypeOfEnterToClassReport(Long id, String title, String complex, Double baseOnComplex, String assistant, Double baseOnAssistant, Double darsadAzComplex, String affairs, Double baseOnAffairs, Double darsadAzOmor) {
        this.id = id;
        this.title = title;
        this.complex = complex;
        this.baseOnComplex = baseOnComplex;
        this.assistant = assistant;
        this.baseOnAssistant = baseOnAssistant;
        this.darsadAzComplex = darsadAzComplex;
        this.affairs = affairs;
        this.baseOnAffairs = baseOnAffairs;
        this.darsadAzOmor = darsadAzOmor;
    }
}
