package com.nicico.training.repository;

import com.nicico.training.model.Term;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TermDAO  extends JpaRepository<Term, Long>, JpaSpecificationExecutor<Term> {


}
