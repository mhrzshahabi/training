package com.nicico.training.repository;

import com.nicico.training.model.TargetSociety;
import java.util.List;

public interface TargetSocietyDAO extends BaseDAO<TargetSociety, Long> {
    List<TargetSociety> findAllByTclassId(Long id);
}
