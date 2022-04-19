package com.nicico.training.repository;

import com.nicico.training.model.ForeignLangKnowledge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ForeignLangKnowledgeDAO extends JpaRepository<ForeignLangKnowledge, Long>, JpaSpecificationExecutor<ForeignLangKnowledge> {

    List<ForeignLangKnowledge> findAllByTeacherId(Long teacherId);
}
