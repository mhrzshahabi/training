package com.nicico.training.repository;

import com.nicico.training.model.ClassDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClassDocumentDAO extends JpaRepository<ClassDocument, Long>, JpaSpecificationExecutor<ClassDocument> {

    List<ClassDocument> findClassDocumentByTclassId(Long id);

    @Query(value = "select cd.C_LETTER_NUM from TBL_CLASS_DOCUMENT cd where cd.F_CLASS_ID =:classId", nativeQuery = true)
    List<String> findAllLetterNumByClassId(Long classId);
}
