package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/
import com.nicico.training.model.ClassDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClassDocumentDAO extends JpaRepository<ClassDocument, Long>, JpaSpecificationExecutor<ClassDocument> {

    List<ClassDocument> findClassDocumentByTclassId(Long id);

}
