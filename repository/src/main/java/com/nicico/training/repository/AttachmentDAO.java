package com.nicico.training.repository;

import com.nicico.training.model.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AttachmentDAO extends JpaRepository<Attachment, Long>, JpaSpecificationExecutor<Attachment> {
}
