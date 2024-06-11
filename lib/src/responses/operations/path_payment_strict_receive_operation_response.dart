import 'operation_responses.dart';
import '../../assets.dart';
import '../../asset_type_native.dart';

/// Represents PathPaymentStrictReceive operation response.
/// See: <a href="https://developers.stellar.org/network/horizon/api-reference/resources/operations/object/path-payment-strict-receive" target="_blank">Operation documentation</a>
class PathPaymentStrictReceiveOperationResponse extends OperationResponse {
  String amount;
  String? sourceAmount;
  String? sourceMax;
  String from;
  String to;

  String? fromMuxed;
  String? fromMuxedId;
  String? toMuxed;
  String? toMuxedId;

  String assetType;
  String? assetCode;
  String? assetIssuer;

  String? sourceAssetType;
  String? sourceAssetCode;
  String? sourceAssetIssuer;
  List<Asset> path;

  PathPaymentStrictReceiveOperationResponse(
      this.amount,
      this.sourceAmount,
      this.sourceMax,
      this.from,
      this.fromMuxed,
      this.fromMuxedId,
      this.to,
      this.toMuxed,
      this.toMuxedId,
      this.assetType,
      this.assetCode,
      this.assetIssuer,
      this.sourceAssetType,
      this.sourceAssetCode,
      this.sourceAssetIssuer,
      this.path);

  Asset get asset {
    if (assetType == Asset.TYPE_NATIVE) {
      return AssetTypeNative();
    } else {
      return Asset.createNonNativeAsset(assetCode!, assetIssuer!);
    }
  }

  Asset get sourceAsset {
    if (sourceAssetType == Asset.TYPE_NATIVE) {
      return AssetTypeNative();
    } else {
      return Asset.createNonNativeAsset(sourceAssetCode!, sourceAssetIssuer!);
    }
  }

  factory PathPaymentStrictReceiveOperationResponse.fromJson(Map<String, dynamic> json) =>
      PathPaymentStrictReceiveOperationResponse(
        json['amount'],
        json['source_amount'],
        json['source_max'],
        json['from'],
        json['from_muxed'],
        json['from_muxed_id'],
        json['to'],
        json['to_muxed'],
        json['to_muxed_id'],
        json['asset_type'],
        json['asset_code'],
        json['asset_issuer'],
        json['source_asset_type'],
        json['source_asset_code'],
        json['source_asset_issuer'],
        List<Asset>.from(json['path'].map((e) => Asset.fromJson(e))),
      )
        ..id = int.tryParse(json['id'])
        ..sourceAccount = json['source_account']
        ..sourceAccountMuxed =
            json['source_account_muxed']
        ..sourceAccountMuxedId =
            json['source_account_muxed_id']
        ..pagingToken = json['paging_token']
        ..createdAt = json['created_at']
        ..transactionHash = json['transaction_hash']
        ..transactionSuccessful = json['transaction_successful']
        ..type = json['type']
        ..links = json['_links'] == null ? null : OperationResponseLinks.fromJson(json['_links']);
}
