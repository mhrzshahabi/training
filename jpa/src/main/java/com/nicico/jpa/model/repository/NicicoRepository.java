package com.nicico.jpa.model.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;

@NoRepositoryBean
public interface NicicoRepository<T> extends JpaRepository<T , Long>, JpaSpecificationExecutor<T> {
}
