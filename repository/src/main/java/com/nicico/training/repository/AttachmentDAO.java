package com.nicico.training.repository;

import com.nicico.training.model.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface AttachmentDAO extends JpaRepository<Attachment, Long>, JpaSpecificationExecutor<Attachment> {

    @Transactional
    List<Attachment> findByEntityNameAndObjectId(@Param("entityName") String entityName,
                                                 @Param("objectId") Long objectId);

    @Transactional
    List<Attachment> findByEntityName(@Param("entityName") String entityName);

}
