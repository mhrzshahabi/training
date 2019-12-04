package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.iservice.IAttachmentService;
import com.nicico.training.model.Attachment;
import com.nicico.training.repository.AttachmentDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AttachmentService implements IAttachmentService {

    @Value("${nicico.upload.dir}")
    private String uploadDir;

    private final ModelMapper modelMapper;
    private final AttachmentDAO attachmentDAO;

    @Transactional(readOnly = true)
    @Override
    public AttachmentDTO.Info get(Long id) {
        final Optional<Attachment> gById = attachmentDAO.findById(id);
        final Attachment attachment = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(attachment, AttachmentDTO.Info.class);
    }

//    @Transactional(readOnly = true)
//    @Override
//    public List<AttachmentDTO.Info> list(String entityName, Long objectId) {
//        final List<Attachment> gAll;
////        if (objectId != null)
////            gAll = attachmentDAO.findByEntityNameAndObjectId(entityName, objectId);
////        else if (entityName != null)
////            gAll = attachmentDAO.findByEntityName(entityName);
////        else
////            gAll = attachmentDAO.findAll();
////        return modelMapper.map(gAll, new TypeToken<List<AttachmentDTO.Info>>() {}.getType());
//        return null;
//    }

    @Transactional
    @Override
    public AttachmentDTO.Info create(AttachmentDTO.Create request) {
        final Attachment attachment = modelMapper.map(request, Attachment.class);
        try {
            return modelMapper.map(attachmentDAO.saveAndFlush(attachment), AttachmentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public AttachmentDTO.Info update(Long id, AttachmentDTO.Update request) {
        final Optional<Attachment> cById = attachmentDAO.findById(id);
        final Attachment attachment = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Attachment updating = new Attachment();
        modelMapper.map(attachment, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(attachmentDAO.saveAndFlush(updating), AttachmentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Attachment> one = attachmentDAO.findById(id);
        final Attachment attachment = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String fileFullPath = uploadDir + File.separator + attachment.getObjectType() + File.separator + attachment.getId();
        try {
            attachmentDAO.delete(attachment);
            File file = new File(fileFullPath);
            new File(uploadDir + File.separator + attachment.getObjectType() + File.separator + "deleted").mkdirs();
            File movedFile = new File(uploadDir + File.separator + attachment.getObjectType() + File.separator + "deleted" + File.separator + attachment.getId());
            file.renameTo(movedFile);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(AttachmentDTO.Delete request) {
        for (Long id : request.getIds()) {
            delete(id);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AttachmentDTO.Info> search(SearchDTO.SearchRq request, String objectType, Long objectId) {

        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (objectType != null)
            list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        if (objectId != null)
            list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));

        if (objectId != null || objectType != null) {

            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);

            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }

        return SearchUtil.search(attachmentDAO, request, attachment -> modelMapper.map(attachment, AttachmentDTO.Info.class));
    }


    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    // ------------------------------

}
