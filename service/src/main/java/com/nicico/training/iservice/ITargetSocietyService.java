package com.nicico.training.iservice;

import com.nicico.training.dto.TargetSocietyDTO;

import java.util.Iterator;
import java.util.List;

public interface ITargetSocietyService {
    List<TargetSocietyDTO.Info> getTargetSocietiesById(Iterator<TargetSocietyDTO.Info> infoIterator, Long targetType);
}
