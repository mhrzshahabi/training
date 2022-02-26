package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ElsCatAndSub {
    private List<Long> categories;
    private List<Long> subCategories;
}
