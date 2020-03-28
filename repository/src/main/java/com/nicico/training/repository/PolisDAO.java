package com.nicico.training.repository;

import com.nicico.training.model.Polis;

import java.util.List;

public interface PolisDAO extends BaseDAO<Polis,Long>{

    boolean existsByNameFa(String nameFa);

    boolean existsByNameFaAndIdIsNot(String nameFa, Long id);
}
