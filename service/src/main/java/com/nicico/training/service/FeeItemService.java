package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.iservice.IFeeItemService;
import com.nicico.training.mapper.FeeItem.FeeItemMapper;
import com.nicico.training.model.ClassFee;
import com.nicico.training.model.FeeItem;
import com.nicico.training.repository.ClassFeeDAO;
import com.nicico.training.repository.FeeItemDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FeeItemService implements IFeeItemService {

    private final ClassFeeDAO classFeeDAO;
    private final FeeItemDAO feeItemDAO;
    private final TclassDAO tclassDAO;
    private final FeeItemMapper mapper;

    @Override
    public FeeItem get(Long id) {
        return feeItemDAO.findById(id)
                .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public FeeItemDTO.Info create(FeeItemDTO.Create request) {
        FeeItem feeItem = mapper.toEntity(request);
        if (feeItem.getClassId() != null) {
            tclassDAO.findById(feeItem.getClassId()).ifPresent(tclass -> feeItem.setClassTitle(tclass.getTitleClass()));
        }
        FeeItem savedFeeItem = feeItemDAO.save(feeItem);
        return mapper.toInfo(savedFeeItem);
    }

    @Override
    public FeeItemDTO.Info update(FeeItemDTO.Create update, Long id) {
        FeeItem feeItem = get(id);
        FeeItem updated = mapper.update(update, feeItem);
        FeeItem saved = feeItemDAO.save(updated);
        FeeItemDTO.Info info = mapper.toInfo(saved);
        if (info.getClassId() != null) {
            tclassDAO.findById(info.getClassId()).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass()));
        }
        return info;
    }

    @Override
    public SearchDTO.SearchRs<FeeItemDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException {
        return SearchUtil.search(feeItemDAO, request, feeItem -> {
            FeeItemDTO.Info info = mapper.toInfo(feeItem);
            if (info.getClassId() != null) {
                tclassDAO.findById(info.getClassId()).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass()));
            }
            return info;
        });
    }

    @Override
    public void delete(Long id) {
        try {
            feeItemDAO.deleteById(id);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public List<FeeItemDTO.Info> getAllByClassId(Long classId) {
        List<FeeItem> feeItemsByClassId = feeItemDAO.findAllByClassId(classId);
        List<FeeItemDTO.Info> infos = mapper.toInfos(feeItemsByClassId);
        infos.forEach(info -> tclassDAO.findById(classId).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass())));
        return infos;
    }

    @Override
    public List<FeeItemDTO.Info> getAllByClassFeeId(Long classFeeId) {
        List<FeeItem> feeItems = feeItemDAO.findAllByClassFeeId(classFeeId);
        return mapper.toInfos(feeItems);
    }


    @Override
    public void deleteAllByParentId(Long id) {
        try {
            Optional<ClassFee> optionalClassFee = classFeeDAO.findById(id);
            if (optionalClassFee.isPresent()) {
                List<FeeItem> allByClassId = feeItemDAO.findAllByClassId(optionalClassFee.get().getClassId());
                feeItemDAO.deleteAll(allByClassId);
            }
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
}
