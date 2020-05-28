package com.nicico.training.repository;

import com.nicico.training.model.TargetSociety;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TargetSocietyDAO extends BaseDAO<TargetSociety, Long> {
    List<TargetSociety> findAllByTclassId(Long id);
    void deleteAllById(List<Long> ids);
}
