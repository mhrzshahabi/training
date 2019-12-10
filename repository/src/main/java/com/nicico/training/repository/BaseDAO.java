package com.nicico.training.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.stereotype.Repository;

import java.io.Serializable;

@NoRepositoryBean
public interface BaseDAO<E, ID extends Serializable> extends JpaRepository<E, ID>, JpaSpecificationExecutor<E> {
}
