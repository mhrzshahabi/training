package com.nicico.training.repository;

import com.nicico.training.model.ForeignLangKnowledge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ForeignLangKnowledgeDAO extends JpaRepository<ForeignLangKnowledge, Long>, JpaSpecificationExecutor<ForeignLangKnowledge> {
}
