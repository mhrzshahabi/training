package com.nicico.training;

import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class CustomModelMapper extends ModelMapper {

    public CustomModelMapper() {
        this.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
    }
}