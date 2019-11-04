package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.iservice.IAttachmentService;
import com.nicico.training.model.Attachment;
import com.nicico.training.repository.AttachmentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AttachmentService implements IAttachmentService {
    private final ModelMapper modelMapper;
    private final AttachmentDAO attachmentDAO;

    @Transactional(readOnly = true)
    @Override
    public AttachmentDTO.Info get(Long id) {
        final Optional<Attachment> gById = attachmentDAO.findById(id);
        final Attachment attachment = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(attachment, AttachmentDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AttachmentDTO.Info> list(String entityName, Long objectId) {
        final List<Attachment> gAll;
        if (objectId != null)
            gAll = attachmentDAO.findByEntityNameAndObjectId(entityName, objectId);
        else if (entityName != null)
            gAll = attachmentDAO.findByEntityName(entityName);
        else
            gAll = attachmentDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<AttachmentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AttachmentDTO.Info create(AttachmentDTO.Create request) {
        final Attachment attachment = modelMapper.map(request, Attachment.class);
        return modelMapper.map(attachmentDAO.save(attachment), AttachmentDTO.Info.class);
    }

    @Transactional
    @Override
    public AttachmentDTO.Info update(Long id, AttachmentDTO.Update request) {
        final Optional<Attachment> cById = attachmentDAO.findById(id);
        final Attachment attachment = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Attachment updating = new Attachment();
        modelMapper.map(attachment, updating);
        modelMapper.map(request, updating);
        return modelMapper.map(attachmentDAO.save(updating), AttachmentDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Attachment> one = attachmentDAO.findById(id);
        final Attachment attachment = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        attachmentDAO.delete(attachment);
    }

    @Transactional
    @Override
    public void delete(AttachmentDTO.Delete request) {
        final List<Attachment> gAllById = attachmentDAO.findAllById(request.getIds());
        attachmentDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AttachmentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(attachmentDAO, request, attachment -> modelMapper.map(attachment, AttachmentDTO.Info.class));
    }

    // ------------------------------

}
