package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class ImportedPersonnelAndPostRequest implements Serializable {
    private String perssonelNumber;
    private String codePost;
}
